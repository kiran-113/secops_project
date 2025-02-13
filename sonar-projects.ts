const scanner = require('sonarqube-scanner');

scanner(
  {
    serverUrl: 'https://sonarcloud.io',
    token: process.env.SONAR_TOKEN, // Use environment variable
    options: {
      'sonar.organization': 'your-org', // Required for SonarCloud
      'sonar.projectKey': 'razopay-integration-test',
      'sonar.projectName': 'razopay-integration-test',
      'sonar.projectDescription': 'Description for "razopay-integration-test" project...',
      'sonar.sources': 'src',
      'sonar.tests': 'test',
      'sonar.javascript.lcov.reportPaths': 'coverage/lcov.info', // Add coverage if available
      'sonar.exclusions': '**/node_modules/**, **/dist/**', // Exclude unwanted files
    },
  },
  error => {
    if (error) {
      console.error('SonarQube scan failed:', error);
    } else {
      console.log('SonarQube scan completed successfully.');
    }
    process.exit();
  },
);
