dockerNode(image: "perl-jenkins-slave") {
   stage('Preparation') {
	  checkout scm
   }

   stage('Install deps') {
      sh "cpanm --installdeps ."
      //sh "cpanm -M http://cpan --installdeps ."
   }
   stage('Test') {
      sh "prove -I ~/perl5/lib/perl5/ -l t --timer --formatter=TAP::Formatter::JUnit  > ${BUILD_TAG}-junit.xml"
   }
   stage('Results') {
      junit '*junit.xml'
   }

}
