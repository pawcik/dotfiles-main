# mvn-color based on https://gist.github.com/1027800
RESET="\e[0m"
BLACK="\e[0;30m"
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
BLUE="\e[0;34m"
MAGENTA="\e[0;35m"
CYAN="\e[0;36m"
WHITE="\e[0;37m"
B_BLACK="\e[1;30m"
B_RED="\e[1;31m"
B_GREEN="\e[1;32m"
B_YELLOW="\e[1;33m"
B_BLUE="\e[1;34m"
B_MAGENTA="\e[1;35m"
B_CYAN="\e[1;36m"
B_WHITE="\e[1;37m"

PHASE1="$B_BLACK"
PHASE2="$B_BLUE"
PHASE_NAME="$B_CYAN"
TEST_PASS="$GREEN"
TEST_FAILURE="\e[43;1;33m"
#TEST_FAILURE="\e[7;40;1;33m"
TEST_ERROR="\e[41;1;37m"
 
# Wrapper function for Maven's mvn command.
mvn-color()
{
  (
  command mvn "$@" \
  | perl -pe "
    s/(?<=\[INFO\] )(?=Building )/${MAGENTA}/;
    s/(?<=\[INFO\] )(--- )(\S+?)(:\S+?:)(\S+?)( \()(.+?)(\).* ---)$/$PHASE1\1$PHASE2\2$PHASE1\3$PHASE2\4$PHASE1\5$PHASE_NAME\6$PHASE1\7/;
    s/(\[WARNING\].*)$/${YELLOW}\1/;
    s/(?<=\[INFO\] )(?=BUILD SUCCESS)/${GREEN}/;
    s/(?<=\[INFO\] )(?=BUILD FAILURE)/${RED}/;

    s/(?<=Tests run: )(\d{2,}|[1-9])/${TEST_PASS}\1${RESET}/;

    s/(,\s+?Failures: )(\d{2,}|[1-9])/\1${TEST_FAILURE}\2${RESET}/;
    s/^(?!Tests run: )(.+ <<< FAILURE!)$/${TEST_FAILURE}\1/;
    s/^(.+?] {5})(?=FAILURE:)/\1${TEST_FAILURE}/;
    s/^(Failed tests:)/${TEST_FAILURE}\1${RESET}/;

    s/(,\s+?Errors: )(\d{2,}|[1-9])/\1${TEST_ERROR}\2${RESET}/;
    s/^(?!Tests run: )(.+ <<< ERROR!)$/${TEST_ERROR}\1/;
    s/^(.+?] {5})(?=ERROR:)/\1${TEST_ERROR}/;
    s/^(Tests in error:)/${TEST_ERROR}\1${RESET}/;

    s/^\[ERROR\]\s*$//;
    s/^\[ERROR\] To see the full stack trace of the errors, re-run Maven with the -e switch.[\r\n]+$//;
    s/^\[ERROR\] Re-run Maven using the -X switch to enable full debug logging.[\r\n]+$//;
    s/^\[ERROR\] For more information about the errors and possible solutions, please read the following articles:[\r\n]+$//;
    s/^\[ERROR\] -> .Help .*[\r\n]+$//;
    s@^\[ERROR\] .Help .. http://cwiki.apache.org/.*[\r\n]+\$@@;
    s/(\[ERROR\].*)$/${RED}\1/;

    s/$/${RESET}/;
  "
  )
}
 
# Override the mvn command with the colorized one.
alias mvn="mvn-color"

# aliases
alias mvncie='mvn clean install eclipse:eclipse'
alias mvnci='mvn clean install'
alias mvne='mvn eclipse:eclipse'
alias mvnce='mvn clean eclipse:clean eclipse:eclipse'
alias mvnd='mvn deploy'
alias mvnp='mvn package'
alias mvnc='mvn clean'
alias mvncom='mvn compile'
alias mvnt='mvn test'
alias mvnag='mvn archetype:generate'

function listMavenCompletions { 
     reply=(
        # common lifecycle
        validate clean generate-sources process-resources compile process-test-resources test-compile test package integration-test verify install deploy site
        
        # common plugins
        deploy failsafe install site surefire checkstyle javadoc jxr pmd ant antrun archetype assembly dependency enforcer gpg help release repository source eclipse idea jetty cargo jboss tomcat tomcat6 tomcat7 exec versions war ear ejb android scm buildnumber nexus repository sonar license hibernate3 liquibase flyway gwt
       
        # deploy
        deploy:deploy-file
        # failsafe
        failsafe:integration-test failsafe:verify
        # install
        install:install-file
        # site
        site:site site:deploy site:run site:stage site:stage-deploy
        # surefire
        surefire:test
            
        # checkstyle
        checkstyle:checkstyle checkstyle:check
        # javadoc
        javadoc:javadoc javadoc:jar javadoc:aggregate
        # jxr
        jxr:jxr
        # pmd
        pmd:pmd pmd:cpd pmd:check pmd:cpd-check

        # ant
        ant:ant ant:clean
        # antrun
        antrun:run
        # archetype
        archetype:generate archetype:create-from-project archetype:crawl
        # assembly
        assembly:single assembly:assembly
        # dependency
        dependency:analyze dependency:analyze-dep-mgt dependency:analyze-only dependency:analyze-report dependency:build-classpath dependency:copy dependency:copy-dependencies dependency:get dependency:go-offline dependency:list dependency:purge-local-repository dependency:resolve dependency:resolve-plugins dependency:sources dependency:tree dependency:unpack dependency:unpack-dependencies
        # enforcer
        enforcer:enforce
        # gpg
        gpg:sign gpg:sign-and-deploy-file
        # help
        help:active-profiles help:all-profiles help:describe help:effective-pom help:effective-settings help:evaluate help:expressions help:system
        # release
        release:clean release:prepare release:rollback release:perform release:stage release:branch release:update-versions
        # repository
        repository:bundle-create repository:bundle-pack
        # source
        source:aggregate source:jar source:jar-no-fork
            
        # eclipse
        eclipse:clean eclipse:eclipse
        # idea
        idea:clean idea:idea
            
        # jetty
        jetty:run jetty:run-exploded
        # cargo
        cargo:start cargo:run cargo:stop cargo:deploy cargo:undeploy cargo:help
        # jboss
        jboss:start jboss:stop jboss:deploy jboss:undeploy jboss:redeploy
        # tomcat
        tomcat:start tomcat:stop tomcat:deploy tomcat:undeploy tomcat:redeploy
        # tomcat6
        tomcat6:run tomcat6:run-war tomcat6:run-war-only tomcat6:stop tomcat6:deploy tomcat6:undeploy
        # tomcat7
        tomcat7:run tomcat7:run-war tomcat7:run-war-only tomcat7:deploy
        # exec
        exec:exec exec:java
        # versions
        versions:display-dependency-updates versions:display-plugin-updates versions:display-property-updates versions:update-parent versions:update-properties versions:update-child-modules versions:lock-snapshots versions:unlock-snapshots versions:resolve-ranges versions:set versions:use-releases versions:use-next-releases versions:use-latest-releases versions:use-next-snapshots versions:use-latest-snapshots versions:use-next-versions versions:use-latest-versions versions:commit versions:revert
        # scm
        scm:add scm:checkin scm:checkout scm:update scm:status
        # buildnumber
        buildnumber:create buildnumber:create-timestamp buildnumber:help buildnumber:hgchangeset

        # war
        war:war war:exploded war:inplace war:manifest
        # ear
        ear:ear ear:generate-application-xml
        # ejb
        ejb:ejb
        # android
        android:apk android:apklib android:deploy android:deploy-dependencies android:dex android:emulator-start android:emulator-stop android:emulator-stop-all android:generate-sources android:help android:instrument android:manifest-update android:pull android:push android:redeploy android:run android:undeploy android:unpack android:version-update android:zipalign android:devices
        # nexus
        nexus:staging-list nexus:staging-close nexus:staging-drop nexus:staging-release nexus:staging-build-promotion nexus:staging-profiles-list nexus:settings-download
        # repository
        repository:bundle-create repository:bundle-pack repository:help

        # sonar
        sonar:sonar
        # license
        license:format license:check
        # hibernate3
        hibernate3:hbm2ddl hibernate3:help
        # liquibase
        liquibase:changelogSync liquibase:changelogSyncSQL liquibase:clearCheckSums liquibase:dbDoc liquibase:diff liquibase:dropAll liquibase:help liquibase:migrate liquibase:listLocks liquibase:migrateSQL liquibase:releaseLocks liquibase:rollback liquibase:rollbackSQL liquibase:status liquibase:tag liquibase:update liquibase:updateSQL liquibase:updateTestingRollback
        # flyway
        flyway:clean flyway:history flyway:init flyway:migrate flyway:status flyway:validate
        # gwt
        gwt:browser gwt:clean gwt:compile gwt:compile-report gwt:css gwt:debug gwt:eclipse gwt:eclipseTest gwt:generateAsync gwt:help gwt:i18n gwt:mergewebxml gwt:resources gwt:run gwt:sdkInstall gwt:source-jar gwt:soyc gwt:test

        # options
        -Dmaven.test.skip=true -DskipTests -Dmaven.surefire.debug -DenableCiProfile -Dpmd.skip=true -Dcheckstyle.skip=true -Dtycho.mode=maven

        # arguments
        -am -amd -B -C -c -cpu -D -e -emp -ep -f -fae -ff -fn -gs -h -l -N -npr -npu -nsu -o -P -pl -q -rf -s -T -t -U -up -V -v -X

        cli:execute cli:execute-phase 
        archetype:generate generate-sources 
        cobertura:cobertura
        -Dtest= `if [ -d ./src/test/java ] ; then find ./src/test/java -type f -name '*.java' | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dtest=\1?' ; fi`
    ); 
}

compctl -K listMavenCompletions mvn
compctl -K listMavenCompletions mvnDebug
