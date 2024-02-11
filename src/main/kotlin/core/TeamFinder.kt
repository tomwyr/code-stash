package core

import core.TeamFinder.Error.FindingFailed
import com.github.michaelbull.result.*
import data.OpenAiClient

object TeamFinder {
    suspend fun find(description: ProjectDescription): Result<TeamProposal, Error> {
        return getProjectSkills(description).andThen(::searchTeam)
    }

    private suspend fun getProjectSkills(description: ProjectDescription): Result<List<TechSkill>, Error> {
        val answer = OpenAiClient.run {
            val (queryId, message) = generateQueryId() to techQuery(description)
            query(queryId, message).andThen { query(queryId, skillsQuery) }
        }

        return answer.map(SkillsParser::fromAnswer).mapError { FindingFailed }
    }

    fun searchTeam(skills: List<TechSkill>): Result<TeamProposal, Error> {
        TODO()
    }

    sealed class Error {
        data object FindingFailed : Error()
    }
}

private fun techQuery(description: ProjectDescription): String = """
|What tech stack would be best to develop the following application:
|${description.value}
""".trimMargin()

private val skillsQuery = """
|What programming languages would be needed to use this tech stack. List the languages separated by comma.
""".trimMargin()
