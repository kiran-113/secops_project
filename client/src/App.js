// import logo from "./logo.svg";
import "./App.css";
import axios from "axios";
import customCDNScriptLoader from "./utils/customCDNScriptLoader";

function App() {
  // Donation Button Click Handler
  const handleDonationClick = async (e, amount) => {
    e.preventDefault();

    // Loading Razorpay CDN Dynamically
    customCDNScriptLoader("https://checkout.razorpay.com/v1/checkout.js");

    try {
      const { data } = await axios.post("/api/razorpay/generateOrder", {
        amount,
      });

      console.log("Order Data: ", data);

      const options = {
        key: data.razorpayKeyID, // Enter the Key ID generated from the Dashboard
        amount: data.amount, // Amount is in currency subunits. Default currency is INR. Hence, 50000 refers to 50000 paise
        currency: data.currency,
        name: "The God Corp.",
        description: "Test Transaction",
        image:
          "https://static.vecteezy.com/system/resources/previews/008/215/293/non_2x/funny-funky-monkey-line-pop-art-logo-colorful-design-with-dark-background-abstract-illustration-isolated-black-background-for-t-shirt-poster-clothing-merch-apparel-badge-design-vector.jpg",
        order_id: data.id, //This is a sample Order ID. Pass the `id` obtained in the response of Step 1
        callback_url: "http://localhost:5000/api/razorpay/paymentConfirmation",
        redirect: true,
        prefill: {
          name: "John Doe",
          email: "john.doe@example.com",
          contact: "6969696969",
        },
        notes: {
          address: "Planet earth",
          ...data.notes,
        },
        theme: {
          color: "#0544A8",
        },
      };

      const razorpay = new window.Razorpay(options);
      razorpay.open();
    } catch (error) {
      alert("FAILED TO GENERATE ORDER");
      console.error(error);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <div className="donate-button-section">
          <button
            onClick={(e) => {
              e.preventDefault();
              handleDonationClick(e, 5);
            }}
            className="donate-button"
          >
            Click to Donate ₹5
          </button>

          <button
            onClick={(e) => {
              e.preventDefault();
              handleDonationClick(e, 10);
            }}
            className="donate-button"
          >
            Click to Donate ₹10
          </button>
        </div>
      </header>
    </div>
  );
}

export default App;
