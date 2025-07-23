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

       stage('Deploy and Run Setup Scripts on EC2') {
    steps {
        sshagent(['Djangocicd-EC2']) {
            sh '''
                scp -o StrictHostKeyChecking=no -r app scripts requirements.txt ubuntu@52.90.186.240:/home/ubuntu/Django_CICD/
                
                ssh -o StrictHostKeyChecking=no ubuntu@52.90.186.240 << EOF
                    cd /home/ubuntu/Django_CICD
                    chmod +x scripts/envsetup.sh
                    chmod +x scripts/gunicorn.sh
                    chmod +x scripts/nginx.sh
                    ./scripts/envsetup.sh
                    ./scripts/gunicorn.sh
                    ./scripts/nginx.sh
                EOF
            '''
        }
    }
}

stage('Restart Services on EC2') {
    steps {
        sshagent(['Djangocicd-EC2']) {
            sh '''
                ssh -o StrictHostKeyChecking=no ubuntu@52.90.186.240 << EOF
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
