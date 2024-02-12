package core

import com.github.michaelbull.result.*
import core.TeamFinder.Error.FindingFailed
import data.apis.GitHubApi
import data.apis.OpenAiApi
import data.mappers.fromGitHub
import data.mappers.fromOpenAiAnswer

object TeamFinder {
    suspend fun find(description: ProjectDescription): Result<TeamProposal, Error> {
        return getProjectSkills(description).andThen { skills -> searchTeam(skills) }
    }

    private suspend fun getProjectSkills(description: ProjectDescription): Result<List<TechSkill>, Error> {
        val answer = OpenAiApi.run {
            val (queryId, message) = generateQueryId() to techQuery(description)
            query(queryId, message).andThen { query(queryId, skillsQuery) }
        }

        return answer.map(TechSkill::fromOpenAiAnswer).mapError { FindingFailed }
    }

    private suspend fun searchTeam(skills: List<TechSkill>): Result<TeamProposal, Error> {
        val roles = skills.map { skill ->
            val member = GitHubApi.run {
                val user = searchUsers(skill, limit = 1).single()
                val repos = getUserLanguages(user.login)
                TeamMember.fromGitHub(user, repos)
            }

            ProjectRole(skill, member)
        }

        return Ok(TeamProposal(roles))
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
