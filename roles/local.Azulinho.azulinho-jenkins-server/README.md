This repo contains ansible code to install a jenkins server

When cloning from github, simply run:

    rake

When using galaxy, simply run:

    ansible-galaxy install Azulinho.azulinho-jenkins-server

To consume this role, set the following variables in your group_vars/all
or in a wrapper_role, <wrapper_role/vars/main.yaml>

VARIABLES:

    azulinho_jenkins_server:
      version: 1.592-1.1
      dest: /opt/jenkins
      lib: /var/lib/jenkins
      port: 8080
      prefix: /jenkins
      cli_dest: '/opt/jenkins/jenkins-cli.jar'

      views:
        list:
          - { name: 'All',
              description: 'All',
              includeRegex: '.*',
              columns: &all_columns_view [
                'hudson.views.StatusColumn',
                'hudson.views.WeatherColumn',
                'hudson.views.JobColumn',
                'hudson.views.LastSuccessColumn',
                'hudson.views.LastFailureColumn',
                'hudson.views.LastDurationColumn',
                'hudson.views.BuildButtonColumn']}

          - { name: 'DSL_BUILD',
              description: 'All BUILD jobs built using the DSL',
              includeRegex: 'DSL_BUILD.*',
              columns: *all_columns_view }

          - { name: 'DSL_DEPLOY',
              description: 'All DEPLOY jobs built using the DSL',
              includeRegex: 'DSL_DEPLOY.*',
              columns: *all_columns_view }

        # the pipeline block is used to configure the PIPELINE views
        # in jenkins.
        pipeline:
          - { name: 'PIPELINE1',
              selectedJob: 'DSL_DEPLOY-job1',
              firstJob: 'DSL_DEPLOY-job1',
              noOfDisplayedBuilds: '5',
              buildViewTitle: 'Deployment Pipeline 1' }

          - { name: 'PIPELINE2',
              selectedJob: 'jinja2_deploy_zabbix',
              firstJob: 'jinja2_deploy_zabbix',
              noOfDisplayedBuilds: '5',
              startsWithParameters: true,
              buildViewTitle: 'Zabbix Deployment Pipeline' }

