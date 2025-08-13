pipeline{
    agent any
    environment{
        IMAGE_NAME='tambesagar28/node-api'
    }
    stages{

        stage('Checkout'){
            step{
                Checkout scm
            }
        }

        stage('Image Build'){
            steps{
                script{
                    def imgTag="${env.BUILD_NUMBER}"
                    withCredentials([ usernamePassword(credentialsId: 'dockerhub-creds',
                                                        usernameVariable: 'DOCKERHUB_USER',
                                                        passwordVariable: 'DOCKERHUB_PASSWORD')]){
                                                            sh '''
                                                                echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USER}" --password-stdin
                                                                docker build -t "${IMAGE_NAME}":"${imgTag}" .
                                                                docker push "${IMAGE_NAME}":"${imgTag}"
                                                                '''
                                                        }                                 
                }
            }
        }

        stage('Update k8s Manifest and Deploy'){
            steps{
                script{
                    withCredentials([file (credentialsId : 'kubeconfig', variable: 'KUBECONFIG_FILE')]){
                        export KUBECONFIG=$KUBECONFIG_FILE
                        TAG="${env.BUIULD_NUMBER}"
                        sed "s/BUILD_NUMBER_PLACEHOLDER/${TAG}/g" k8s/deployment.yaml > k8s/deployment.applied.yaml
                        kubectl apply -f k8s/deployment.applied.yaml
                        kubectl apply -f k8s/service.yaml

                    }
                }
            }
        }
    }

    post{
        always{
            echo "Pipeline Finished"
        }
    }
}