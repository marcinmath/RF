#!/usr/bin/env groovy

import hudson.model.*
import hudson.plugins.jira.*
import hudson.plugins.warnings.*


pipeline {
    agent any

    stages {
         stage('Dry-run') {
            steps{
	        sh """
		set +e
                mkdir -p ${WORKSPACE}/results
                pybot  --dryrun --outputdir ${WORKSPACE}/results ${WORKSPACE}
            """
            step([$class: 'RobotPublisher', outputPath: "${WORKSPACE}/results", passThreshold: 100, unstableThreshold: 90, onlyCritical: true, otherFiles: ""])
            }
        }
        stage('Test') {
            steps {
                sh """
		set +e
                mkdir -p ${WORKSPACE}/results
                pybot --outputdir ${WORKSPACE}/results ${WORKSPACE}/REST_WSB.robot
            """
	    step([$class: 'RobotPublisher', outputPath: "${WORKSPACE}/results", passThreshold: 100, unstableThreshold: 90, onlyCritical: true, otherFiles: ""])
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}


