window.__firefox__.execute(function($, $Object) {
  if (window.isSecureContext) {
    if (!window.ethereum) {
      return
    }
    let uuid = crypto.randomUUID();
    if (!uuid) {
      return
    }
    function announceProvider() {
      const info = {
        walletId: "com.brave.wallet",
        rdns: "com.brave.wallet",
        uuid: uuid,
        name: "Brave Wallet",
        icon: "TBD",
      };
      let provider = window.ethereum
      const event = new CustomEvent("eip6963:announceProvider", {
        detail: $Object.freeze({ info, provider }),
      });
      window.dispatchEvent(event);
    }
    window.addEventListener(
      "eip6963:requestProvider",
      (event) => {
        announceProvider();
      }
    );
    
    announceProvider();
  }
});
