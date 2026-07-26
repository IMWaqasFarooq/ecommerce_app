import {onRequest} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import Stripe from "stripe";

admin.initializeApp();

const stripeSecretKey = defineSecret("STRIPE_SECRET_KEY");

const SUPPORTED_CURRENCIES = new Set(["usd", "eur", "gbp"]);

export const createPaymentIntent = onRequest(
  {secrets: [stripeSecretKey], cors: true},
  async (request, response) => {
    if (request.method !== "POST") {
      response.status(405).send({error: "Method not allowed"});
      return;
    }

    const authHeader = request.headers.authorization ?? "";
    const idToken = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : null;
    if (!idToken) {
      response.status(401).send({error: "Missing bearer token"});
      return;
    }

    try {
      await admin.auth().verifyIdToken(idToken);
    } catch (error) {
      logger.warn("Rejected request with invalid ID token", error);
      response.status(401).send({error: "Invalid or expired session"});
      return;
    }

    const {amount, currency} = request.body ?? {};
    const normalizedCurrency = typeof currency === "string" ? currency.toLowerCase() : "";

    if (!Number.isInteger(amount) || amount <= 0) {
      response.status(400).send({error: "amount must be a positive integer (smallest currency unit)"});
      return;
    }
    if (!SUPPORTED_CURRENCIES.has(normalizedCurrency)) {
      response.status(400).send({error: `currency must be one of ${[...SUPPORTED_CURRENCIES].join(", ")}`});
      return;
    }

    const stripe = new Stripe(stripeSecretKey.value());

    try {
      const paymentIntent = await stripe.paymentIntents.create({
        amount,
        currency: normalizedCurrency,
        automatic_payment_methods: {enabled: true},
      });

      response.status(200).send({
        clientSecret: paymentIntent.client_secret,
        paymentIntentId: paymentIntent.id,
      });
    } catch (error) {
      logger.error("Stripe PaymentIntent creation failed", error);
      response.status(502).send({error: "Payment provider error"});
    }
  },
);
