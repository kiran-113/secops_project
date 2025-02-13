const scanner = require('sonarqube-scanner').default;

scanner(
  {
    serverUrl: 'http://localhost:9000', // SonarQube running on Docker
    token: process.env.SONAR_TOKEN, // Set your SonarQube token
    options: {
      'sonar.projectKey': 'secops_project',
      'sonar.sources': '.', // Scan the entire project
      'sonar.exclusions': '**/node_modules/**, **/client/**', // Exclude unnecessary dirs
      'sonar.javascript.lcov.reportPaths': 'coverage/lcov.info', // Add if you have test coverage
    },
  },
  error => {
    if (error) console.error('SonarQube scan failed:', error);
    else console.log('SonarQube scan completed successfully.');
    process.exit();
  },
);

//// soanr cloud
// const scanner = require('sonarqube-scanner').default;

// scanner(
//   {
//     serverUrl: 'https://sonarcloud.io',  // Change if using a self-hosted SonarQube
//     token: process.env.SONAR_TOKEN,
//     options: {
//       'sonar.projectKey': 'secops_project',
//       'sonar.organization': 'your-org',  // Required for SonarCloud
//       'sonar.sources': '.', // Scan entire project
//       'sonar.exclusions': '**/node_modules/**, **/client/**', // Exclude unnecessary dirs
//       'sonar.javascript.lcov.reportPaths': 'coverage/lcov.info', // Add if you have tests
//     },
//   },
//   error => {
//     if (error) console.error('SonarQube scan failed:', error);
//     else console.log('SonarQube scan completed successfully.');
//     process.exit();
//   },
// );
