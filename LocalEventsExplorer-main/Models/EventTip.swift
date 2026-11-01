
import Foundation
import FoundationModels

@Generable
struct EventTip {

    @Guide(description: "Suggest suitable clothing for attending this event.")
    var outfitSuggestion: String

    @Guide(description: "Suggest an important item to bring to this event.")
    var itemToBring: String

    @Guide(description: "Give useful advice about when to arrive.")
    var arrivalTip: String
}
