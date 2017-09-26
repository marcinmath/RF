#!/usr/bin/env groovy

import hudson.model.*
import hudson.plugins.jira.*
import hudson.plugins.warnings.*

def is_master_branch = env.BRANCH_NAME.matches("master.*")

pipeline {
    agent any

    stages {
         stage('Dry-run') {
            steps{
	        sh """
		set +e
		echo  $is_master_branch
                mkdir -p ${WORKSPACE}/results
                pybot  --dryrun --exclude DISABLED --outputdir ${WORKSPACE}/results ${WORKSPACE}
            """
            step([$class: 'RobotPublisher', outputPath: "${WORKSPACE}/results", passThreshold: 100, unstableThreshold: 90, onlyCritical: true, otherFiles: ""])
            }
        }

        stage('RFLINT') {
            steps {
                sh """
                set +e
                python -m rflint -A ${WORKSPACE}/utils/rflint.cfg ${WORKSPACE}/ > rflint.log || exit 0
            """
                step([$class: 'WarningsPublisher', parserConfigurations: [[parserName: 'Robot Framework Lint', pattern: '**/rflint.log']], failedTotalHigh: '23'])
            }
        }
        stage('Test') {
            steps {
                sh """
	        set +e
                mkdir -p ${WORKSPACE}/results
                pybot --exclude DISABLED --outputdir ${WORKSPACE}/results ${WORKSPACE}/REST_WSB.robot
            """
                step([$class: 'RobotPublisher', outputPath: "${WORKSPACE}/results", passThreshold: 100, unstableThreshold: 90, onlyCritical: true, otherFiles: ""])
            }
        }
        stage('Publish') {
            steps {
                echo 'Publishing....'
                archiveArtifacts artifacts: 'results/*,rflint.log'
            }
        }
    }
}


