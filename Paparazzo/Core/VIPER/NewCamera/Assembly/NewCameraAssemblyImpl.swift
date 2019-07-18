import UIKit

final class NewCameraAssemblyImpl:
    BasePaparazzoAssembly,
    NewCameraAssembly
{
    // MARK: - NewCameraAssembly
    func module(
        selectedImagesStorage: SelectedImageStorage,
        configure: (NewCameraModule) -> ())
        -> UIViewController
    {
        let interactor = NewCameraInteractorImpl()
        
        let viewController = NewCameraViewController(
            selectedImagesStorage: selectedImagesStorage,
            cameraService: serviceFactory.cameraService(initialActiveCameraType: .back)
        )
        
        let router = NewCameraRouterImpl(viewController: viewController)
        
        let presenter = NewCameraPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
