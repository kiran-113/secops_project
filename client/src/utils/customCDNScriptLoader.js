const customCDNScriptLoader = (url) => {
  const script = document.createElement("script");
  script.src = url;
  document.body.appendChild(script);
};

export default customCDNScriptLoader;
