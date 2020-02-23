#!/bin/sh
set -x

result='sonar-scanner -Dsonar.login=$1 -Dsonar.host.url=$2 -Dsonar.projectKey=$3 Dsonar.projectKey=$4'


sonar_task_id=$(echo $result | egrep -o "task\?id=[^ ]+" | cut -d'=' -f2)
# Allow time for SonarQube Background Task to complete
stat="PENDING";
        while [ "$stat" != "SUCCESS" ]; do
          if [ $stat = "FAILED" ] || [ $stat = "CANCELLED" ]; then
            echo "SonarCloud task $sonar_task_id failed";
            exit 1;
          fi
          stat=$(curl -u $LOGIN: $sonar_host_url/api/ce/task\?id=$sonar_task_id | jq -r '.task.status');
          echo "SonarQube analysis status is $stat";
          sleep 5;
        done
      sonar_analysis_id=$(curl -u $LOGIN: $sonar_host_url/api/ce/task\?id=$sonar_task_id | jq -r '.task.analysisId')
      quality_status=$(curl -u $LOGIN: $sonar_host_url/api/qualitygates/project_status\?analysisId=$sonar_analysis_id | jq -r '.projectStatus.status')
        if [ $quality_status = "ERROR" ]; then
          content=$(echo "SonarQube analysis complete. Quality Gate Failed.\n\nTo see why, $sonar_link");
          $CODEBUILD_BUILD_SUCCEEDING -eq 0 ;
        elif [ $quality_status = "OK" ]; then
          content=$(echo "SonarQube analysis complete. Quality Gate Passed.\n\nFor details, $sonar_link");
          #aws codecommit update-pull-request-approval-state --pull-request-id $PULL_REQUEST_ID --approval-state APPROVE --revision-id $REVISION_ID;
        else
          content="An unexpected error occurred while attempting to analyze with SonarQube.";
        fi

