pipeline {

	agent any
  
    environment {
		SELENIUMHUB="seleniumhub"
		TESTTYPE="nonreg"
		SQUASH="squash"
	}
    tools { 
        maven 'Maven3' 
        jdk 'JAVA8' 
    }
	
	triggers { cron('H 7 * * 1-5') }

	stages {	
      
		stage('Setting Up Selenium Grid') {
			steps{
				script {
					seleniumStatus()
					
					// creating a new network
					sh 'docker network create SELTEST'
					
					// creating container for seleniumhub and chrome and connecting them to the network mynetwork
					sh 'docker run -d -p 4444:4444 --name '+SELENIUMHUB+' --network SELTEST selenium/hub:3.141.59'
					sh 'docker run -d -v /home/seluser/attachments:/home/seluser/attachments -e HUB_PORT_4444_TCP_ADDR='+SELENIUMHUB+' -e HUB_PORT_4444_TCP_PORT=4444 -e NODE_MAX_INSTANCES=10 -e NODE_MAX_SESSION=10 --network SELTEST --name chrome selenium/node-chrome:3.141.59'
					
					//sh 'docker run -d -p 4444:4444 -v /dev/shm:/dev/shm --name chromeAlone selenium/standalone-chrome:3.141.59'
					//testImage('standalone-chrome:3.141.59')					
					
					//sh 'docker network ls'
					//sh 'docker image ls'
					//sh 'docker ps'
					//sh 'docker run -d  --name '+SELENIUMHUB+'  132.147.15.127:8085/selenium-pricing'
					//Wait 60s for the initialization
					//sh 'sleep 60'
				}
			}
		}
      
      
		stage('Run NonReg tests') {
			
			steps{
				script{
					//Using maven 
					//docker.image('maven:3.6.3-jdk-8').inside('-v /home/seluser/attachments:/tmp') {
				    sh 'mvn clean'
                    sh 'mvn install'
						
					//}
				}
			}
		}
		
       stage('Tearing Down Selenium Grid') {
			steps{
				script{
					sh 'docker container rm -vf chrome'
					sh 'docker container rm -vf '+SELENIUMHUB
					sh 'docker network rm SELTEST'
					
					//copy paste reports to keep 10 latest builds
					//sh 'mkdir -p previousBuilds/${BUILD_NUMBER}/test-output'
					//sh 'cp -r test-output/extent-reports previousBuilds/${BUILD_NUMBER}/test-output'
					//sh 'find previousBuilds/ -maxdepth 1 -mindepth 1 -type d -mtime +10 -exec rm -rv {} \\;'
				}
			}
		}

		
	}
}
def testImage(imageName) {
    docker.image(imageName).inside {
        sh 'echo "Tests passed"'
    }
}

def deleteImage(imageName) {
    script {
        sh "docker rmi ${imageName} --force"
    }
}
def seleniumStatus(){
	script {
		sh 'if docker ps -a | grep -w '+SELENIUMHUB+' > 0; then docker rm -vf '+SELENIUMHUB+'; fi'
		sh 'if docker ps -a | grep -w node-chrome:3.141.59  > 0; then docker rm -vf chrome; fi'
		sh 'if docker network ls | grep -w SEL  > 0; then docker network rm SEL; fi'
	}
}
