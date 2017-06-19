pipeline {
    agent any

    stages {
         stage('Dry run') {
            run """
                mkdir -p ${WORKSPACE}/my_robot_results
                pybot  --dryrun --exclude disabledORnodryrun --outputdir ${WORKSPACE}/my_robot_results ${WORKSPACE}/robot
            """
            step([$class: 'RobotPublisher', outputPath: "${WORKSPACE}/my_robot_results", passThreshold: 100, unstableThreshold: 90, onlyCritical: true, otherFiles: ""])
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}