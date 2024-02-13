package core

import com.github.michaelbull.result.*
import core.TeamFinder.Error.FindingFailed
import data.apis.GitHubApi
import data.apis.OpenAiApi
import data.mappers.fromGitHub
import data.mappers.fromOpenAiAnswer

object TeamFinder {
    suspend fun find(projectDescription: String): Result<TeamComposition, Error> {
        return getProjectSkills(projectDescription)
                .andThen { skills -> searchTeam(skills) }
                .map { roles -> TeamComposition(projectDescription, roles) }
    }

    private suspend fun getProjectSkills(projectDescription: String): Result<List<TechSkill>, Error> {
        val answer = OpenAiApi.run {
            val (queryId, message) = generateQueryId() to techQuery(projectDescription)
            query(queryId, message).andThen { query(queryId, skillsQuery) }
        }

        return answer.map(TechSkill::fromOpenAiAnswer).mapError { FindingFailed }
    }

    private suspend fun searchTeam(skills: List<TechSkill>): Result<List<ProjectRole>, Error> {
        val roles = skills.map { skill ->
            val member = GitHubApi.run {
                val user = searchUsers(skill.language, limit = 1).single()
                val repos = getUserLanguages(user.login)
                TeamMember.fromGitHub(user, repos)
            }

            ProjectRole(skill, member)
        }

        return Ok(roles)
    }

    sealed class Error {
        data object FindingFailed : Error()
    }
}

private fun techQuery(projectDescription: String): String = """
|What tech stack would be best to develop the following application:
|$projectDescription
""".trimMargin()

private val skillsQuery = """
|What programming languages would be needed to use this tech stack. List the languages separated by comma.
""".trimMargin()
