pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://http://35.91.47.158:9000' // update with your SonarQube server URL
        SONAR_PROJECT_KEY = 'secops_project' // update with your SonarQube project key
        SCANNER_HOME = tool 'SonarQubeScanner'  // Ensure this matches the tool name in Jenkins
        ECR_REPOSITORY = 'razorpay-ecr' // Your ECR repository name
        AWS_REGION = 'us-west-2' // Specify your AWS region
        IMAGE_TAG = 'latest' // Specify the image tag
        AWS_ACCOUNT_ID = '127214183072' // Specify your AWS account ID
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout source code from the SCM
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Perform code quality analysis with SonarQube
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_LOGIN_TOKEN')]) {
                    withSonarQubeEnv('sonar-server') {
                        sh '''
                        ${SCANNER_HOME}/bin/sonar-scanner \
                            -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=${SONAR_HOST_URL} \
                            -Dsonar.login=${SONAR_LOGIN_TOKEN}
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                // Wait for SonarQube quality gate check
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image from the Dockerfile
                script {
                    sh '''
                    docker build -t ${ECR_REPOSITORY}:${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('Scan Image with Trivy') {
            steps {
                script {
                    // This stage scans the built Docker image for known vulnerabilities
                    // using Trivy, an open-source vulnerability scanner.
                    // We set the --exit-code to 1 to fail the build if vulnerabilities are found
                    // with a severity of HIGH or CRITICAL. This ensures that only secure images
                    // are pushed to the ECR repository.

                    // Scan the image for vulnerabilities
                    // trivy image --exit-code 1 --severity HIGH,CRITICAL ${ECR_REPOSITORY}:${IMAGE_TAG}
                    sh '''
                        trivy image ${ECR_REPOSITORY}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to AWS ECR
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''

                    // Tag the image for ECR
                    sh '''
                    docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}
                    '''

                    // Push the image to ECR
                    sh '''
                    docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}
                    '''
                }
            }
        }
    }
}


// pipeline {
//     agent any

//     environment {
//         SONAR_HOST_URL = 'http://34.221.129.225:9000//' //'#http://localhost:9090'
//         SONAR_PROJECT_KEY = 'secops_project'
//         SCANNER_HOME = tool 'SonarQubeScanner'  // Ensure this matches the tool name in Jenkins
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 checkout scm
//             }
//         }

//         stage('SonarQube Analysis') {
//             steps {
//                 // Use withCredentials to access the secret
//                 withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_LOGIN_TOKEN')]) {
//                     withSonarQubeEnv('sonar-server') {  // Ensure this matches your SonarQube server name in Jenkins
//                         sh '''
//                         ${SCANNER_HOME}/bin/sonar-scanner \
//                             -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
//                             -Dsonar.sources=. \
//                             -Dsonar.host.url=${SONAR_HOST_URL} \
//                             -Dsonar.login=${SONAR_LOGIN_TOKEN}  // Use the variable for the secret
//                         '''
//                     }
//                 }
//             }
//         }

//         stage('Quality Gate') {
//             steps {
//                 timeout(time: 5, unit: 'MINUTES') {
//                     waitForQualityGate abortPipeline: true
//                 }
//             }
//         }
//     }
// }


