import Foundation
import Kitura
import LoggerAPI
import HeliumLogger


do{
    HeliumLogger.use(LoggerMessageType.info)
    let controller = try Controller()
    Log.info("Server will start on '\(controller.url)'")
    
    Kitura.addHTTPServer(onPort: controller.port, with: controller.router)
    
    Kitura.run()
    
}catch let err{
    
    Log.error(err.localizedDescription)
    Log.error("Server did not start")
    
}
