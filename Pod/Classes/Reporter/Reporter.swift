internal final class Reporter {
    
    static func send(report: Report) {
        
        let params: [String: Any?] = [
            "screenName": report.screenName,
            "screenshot": "file.jpg",
            "text": report.text,
            "identity": ShakeCrash.userId,
            "attribiutes": ShakeCrash.userAttribiutes,
            "logs": ShakeCrash.log.entries,
            "date": Date()
        ]
        
        // TODO
    }
    
}
