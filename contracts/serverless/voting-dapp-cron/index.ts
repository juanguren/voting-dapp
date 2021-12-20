import { api, data, schedule, params } from "@serverless/cloud";

// Create GET route and return users
api.get("/users", async (req, res) => {
  // Get users from Serverless Data
  let result = await data.get("user:*", true);
  // Return the results
  res.send({
    users: result.items,
  });
});

// Redirect to users endpoint
api.get("/*", (req, res) => {
  res.redirect("/users");
});
