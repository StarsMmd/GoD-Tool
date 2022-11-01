import Foundation
import GoDFoundation
import GoDEngine
import GameCube

class EnginePickerViewModel {

    enum Input {
        case file(File)
        case folder(Folder)
    }

    let input: Input

    init(input: Input) {
        self.input = input


    }

}

extension EnginePickerViewModel {
    private static var engines: [Engine] {
        [
            Gamcube.engine
        ]
    }
}
