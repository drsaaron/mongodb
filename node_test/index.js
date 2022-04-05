const { MongoClient } = require("mongodb");

const uri = "mongodb://localhost";
const client = new MongoClient(uri);

console.log(`your home is ${process.env.HOME}`)

async function run() {
  try {
      await client.connect();

      // use my pyTest database, created by the python script above'
      const database = client.db('pyTest');
      const reviews = database.collection('reviews');

      // find some mexican food
      const query = { cuisine: "Mexican" };
      const cuisine = await reviews.findOne(query);
      console.log(cuisine);
  } finally {
      // Ensures that the client will close when you finish/error
      await client.close();
  }
}

run().catch(console.dir);
