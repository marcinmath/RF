#!/usr/bin/env groovy

import hudson.model.*
import hudson.plugins.jira.*
import hudson.plugins.warnings.*


def run(script) {
    catchError {
        sh """set +e
        source ${WORKSPACE}/robot/utils/test_executor_set_environment.sh
        activate
        ${script}"""
    }
}

pipeline {
    agent any

    stages {
         stage('Dry-run') {
            steps{
	        sh """
                mkdir -p ${WORKSPACE}/results
		mkdir -p ${WORKSPACE}/robot
                pybot  --dryrun --exclude disabledORnodryrun --outputdir ${WORKSPACE}/results ${WORKSPACE}/robot
            """
            step([$class: 'RobotPublisher', outputPath: "${WORKSPACE}/results", passThreshold: 100, unstableThreshold: 90, onlyCritical: true, otherFiles: ""])
            }
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


