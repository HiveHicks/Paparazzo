import Marshroute
import UIKit

final class PhotoLibraryV2MarshrouteRouter: BaseRouter, PhotoLibraryV2Router {
    
    typealias AssemblyFactory = MediaPickerMarshrouteAssemblyFactory & NewCameraMarshrouteAssemblyFactory
    
    private let assemblyFactory: AssemblyFactory
    
    init(assemblyFactory: AssemblyFactory, routerSeed: RouterSeed) {
        self.assemblyFactory = assemblyFactory
        super.init(routerSeed: routerSeed)
    }
    
    // MARK: - PhotoLibraryV2Router
    func showMediaPicker(
        data: MediaPickerData,
        overridenTheme: PaparazzoUITheme?,
        isMetalEnabled: Bool,
        configure: (MediaPickerModule) -> ())
    {
        pushViewControllerDerivedFrom { routerSeed in
            
            let assembly = assemblyFactory.mediaPickerAssembly()
            
            return assembly.module(
                data: data,
                overridenTheme: overridenTheme,
                routerSeed: routerSeed,
                isMetalEnabled: isMetalEnabled,
                configure: configure
            )
        }
    }
    
    func showNewCamera(
        selectedImagesStorage: SelectedImageStorage,
        configure: (NewCameraModule) -> ())
    {
        pushViewControllerDerivedFrom { routerSeed in
            
            let assembly = assemblyFactory.newCameraAssembly()
            
            return assembly.module(
                selectedImagesStorage: selectedImagesStorage,
                routerSeed: routerSeed,
                configure: configure
            )
        }
    }
}
