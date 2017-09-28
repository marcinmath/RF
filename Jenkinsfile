#!/usr/bin/env groovy

import hudson.model.*
import hudson.plugins.warnings.*

def is_master_branch = env.BRANCH_NAME.matches("master.*")

try {
    node {
        stage('scm checkout')
                {
                    checkout scm
                }
        stage('Dry-run') {
                sh """
		        set +e
		        echo  $is_master_branch
                mkdir -p ${WORKSPACE}/results
                pybot  --dryrun --exclude DISABLED --outputdir ${WORKSPACE}/results ${WORKSPACE}
            """
                step([$class: 'RobotPublisher', outputPath: "${WORKSPACE}/results", passThreshold: 100, unstableThreshold: 90, onlyCritical: true, otherFiles: ""])

        }
        stage('RFLINT') {
                sh """
                python -m rflint -A ${WORKSPACE}/utils/rflint.cfg ${WORKSPACE}/ > rflint.log || exit 0
            """
                step([$class: 'WarningsPublisher', parserConfigurations: [[parserName: 'Robot Framework Lint', pattern: '**/rflint.log']], failedTotalHigh: '0'])
        }
        if(is_master_branch) {
            stage('Test') {
                sh """
	        set +e
                mkdir -p ${WORKSPACE}/results
                pybot --exclude DISABLED --outputdir ${WORKSPACE}/results ${WORKSPACE}/REST.robot
            """
                step([$class: 'RobotPublisher', outputPath: "${WORKSPACE}/results", passThreshold: 100, unstableThreshold: 90, onlyCritical: true, otherFiles: ""])

            }
            stage('TestRail export') {
                sh """
            echo 'running TestRail export!'
            """
            }
        }
    }

} finally {
    node{
        stage('Publish') {

                echo 'Publishing arfitacts.'
                archiveArtifacts artifacts: 'results/*,rflint.log'
        }
    }
}


