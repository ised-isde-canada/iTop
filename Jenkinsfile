@Library('ised-cicd-lib') _

pipeline {
  agent {
    label 'php-7.3'
  }

  options {
    disableConcurrentBuilds()
  }

  environment {
    // GLobal Vars
    IMAGE_NAME = "ciodrcoe-epic-drupal-wxt"
  }

  stages {
    stage('build') {
      steps {
        script {
          sh"""
            ./composer.phar install --no-interaction --no-ansi --optimize-autoloader
          """
        }
      }
    }
  }
}
