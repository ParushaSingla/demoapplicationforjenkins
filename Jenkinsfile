pipeline {
    agent any
    tools
    {
    	maven 'Maven3'
    	jdk 'JDK 8'
    }
    stages {
       stage('Checkout'){
          steps {
             echo 'build in from master branch'
              git 'https://github.com/ParushaSingla/demoapplicationforjenkins.git'
          }
       }
       stage('Build'){
          steps{
            echo 'building..'
            bat "mvn clean install"
          }
       }
       stage('Unit Testing'){
          steps{
            echo 'testing..'
            bat "mvn test"
          }
       }
       stage('Sonar Analysis'){
        steps{
           echo 'Sonar Analysis..'
           withSonarQubeEnv("Test_Sonar")
           {
             bat "mvn sonar:sonar"
           }
         }
       }
       stage('Upload to Artifactory'){
          steps{
            echo 'Artifactory.. '
            rtMavenDeployer(
            id:'deployer',
            serverId:'123456789@artifactory',
            releaseRepo:'CI-Automation-JAVA',
            snapshotRepo:'CI-Automation-JAVA',
            )
            rtMavenRun(
            pom:'pom.xml',
            goals:'clean install',
            deployerId:'deployer'
            )
            rtPublishBuildInfo(
            serverId:'123456789@artifactory'         
            )
          }
       }      
      stage('Docker Image'){
        steps{
          bat "docker build -t dtr.nagarro.com:443/i_parushasingla_master:${BUILD_NUMBER} . --no-cache -f Dockerfile"
        }
      }
      stage('Push to DTR'){
         steps{
          bat "docker push dtr.nagarro.com:443/i_parushasingla_master:${BUILD_NUMBER}"
           }
       }      
	   stage('Stop the Running container'){
        steps{
           bat """
           docker ps -qf expose=8080 > temp.txt
           set /p commandid=<temp.txt
           echo '%commandid%'
           if [%commandid%]==[] (echo "no running container") else ( 
           docker stop %commandid%  
           docker rm -f %commandid%
           )
          """
       }
      }
	  stage('Docker Deployment'){
        steps{
          bat "docker run -d --name c_parushasingla_master -p  6200:8080 dtr.nagarro.com:443/i_parushasingla_master:${BUILD_NUMBER}"
           }
       }
    }  
}
