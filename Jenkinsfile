node('node1'){
    checkout scm
    dir("home-assignments/0212/session1"){
        stage('Running exercise1'){
            sh 'python3 exercise1.py'
        }   
    }
}
node('node2'){
    checkout scm
    dir("home-assignments/0212/session1"){
        stage('Running exercise2'){
            sh 'python3 exercise2.py'
        }      
    }
}