pipeline {
    agent any
    stages {
        stage('Setup Python Virtual ENV for dependencies') {
            steps {
                sh '''
                chmod +x scripts/envsetup.sh
                ./scripts/envsetup.sh
                '''
            }
        }
        stage('Setup Gunicorn Setup') {
            steps {
                sh '''
                chmod +x scripts/gunicorn.sh
                ./scripts/gunicorn.sh
                '''
            }
        }
        stage('Setup NGINX') {
            steps {
                sh '''
                chmod +x scripts/nginx.sh
                ./scripts/nginx.sh
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['EC2-user']) {
                    sh '''
                    scp -o StrictHostKeyChecking=no -r $WORKSPACE/Django_CICD ubuntu@52.90.186.240:/home/ubuntu/
        
                    ssh -o StrictHostKeyChecking=no ubuntu@52.90.186.240 << EOF
                        cd /home/ubuntu/Django_CICD
                        chmod +x scripts/envsetup.sh
                        chmod +x scripts/gunicorn.sh
                        chmod +x scripts/nginx.sh
                        ./scripts/envsetup.sh
                        ./scripts/gunicorn.sh
                        ./scripts/nginx.sh
                        sudo systemctl daemon-reexec
                        sudo systemctl daemon-reload
                        sudo systemctl restart gunicorn
                        sudo systemctl restart nginx
                    EOF
                    '''
                }
            }
        }


        
    }
}
