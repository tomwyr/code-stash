import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import core.TeamFinder
import utils.describe

suspend fun main() {
    println()
    println("Describe the project to get team composition:")
    val description = readlnOrNull()

    println()
    println("Finding team for the provided description...")

    if (description.isNullOrEmpty()) {
        println()
        println("Cannot compose a team for a project with no description.")
        return
    }

    println()
    when (val result = TeamFinder.find(description)) {
        is Ok -> println(result.value.describe())
        is Err -> println("Could not get team composition. Try again in a few minutes.")
    }
}
