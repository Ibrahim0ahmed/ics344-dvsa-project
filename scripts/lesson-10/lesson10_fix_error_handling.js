/**
 * FIX: Lesson #10 — Unhandled Exceptions
 * File: DVSA-ORDER-MANAGER/order-manager.js (and other Lambda functions)
 *
 * BEFORE (vulnerable):
 *   Unhandled errors return raw stack traces, file paths, and internal
 *   details to the client through API Gateway responses.
 *
 * AFTER (fixed):
 *   Wrap handler logic in try/catch, log full errors to CloudWatch,
 *   return only generic error messages to the client.
 */

// ========== PATTERN: Wrap Lambda handler with safe error handling ==========

// Add at the very beginning of the handler function:
exports.handler = async function(event, context, callback) {
    try {
        // ---- Original handler logic goes here ----

        // ... existing code ...

        // ---- End of original logic ----
    } catch (err) {
        // Log full error details to CloudWatch (internal only)
        console.error("Unhandled error:", JSON.stringify({
            errorMessage: err.message,
            errorStack: err.stack,
            requestId: context.awsRequestId,
            functionName: context.functionName,
            event: {
                httpMethod: event.httpMethod,
                path: event.path
                // Do NOT log the full event body — it may contain sensitive data
            }
        }));

        // Return generic error to client (no internal details)
        return callback(null, {
            statusCode: 500,
            headers: { "Access-Control-Allow-Origin": "*" },
            body: JSON.stringify({
                status: "error",
                message: "An internal error occurred. Please try again later."
            })
        });
    }
};

// ========== ALSO: Add input validation at the start ==========

// Validate required fields before processing
function validateOrderRequest(body) {
    if (!body || typeof body !== 'object') {
        throw { statusCode: 400, message: "Invalid request body" };
    }
    if (!body.action || typeof body.action !== 'string') {
        throw { statusCode: 400, message: "Missing or invalid action" };
    }
    // Add more field-specific validation as needed
}
