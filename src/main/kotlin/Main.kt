import com.github.michaelbull.result.unwrap
import core.ProjectDescription
import core.TeamFinder
import utils.format

suspend fun main() {
    val result = TeamFinder.find(ProjectDescription(mockProjectDescription))

    println(result.unwrap().format())
}
