protocol NewCameraViewInput: class {
    var onCloseButtonTap: (() -> ())? { get set }
    var onDoneButtonTap: (() -> ())? { get set }
}
