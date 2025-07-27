package com.tomwyr

import com.google.devtools.ksp.processing.Dependencies
import com.google.devtools.ksp.processing.Resolver
import com.google.devtools.ksp.processing.SymbolProcessor
import com.google.devtools.ksp.processing.SymbolProcessorEnvironment
import com.google.devtools.ksp.symbol.KSAnnotated
import com.google.devtools.ksp.symbol.KSFunctionDeclaration
import com.google.devtools.ksp.symbol.KSValueParameter
import com.google.devtools.ksp.validate
import java.io.OutputStream

class WithDefaultsProcessor(
    private val environment: SymbolProcessorEnvironment,
) : SymbolProcessor {
    companion object {
        const val packageName = "com.tomwyr"
    }

    override fun process(resolver: Resolver): List<KSAnnotated> {
        val symbols = getFunctionSymbols(resolver)
        if (!symbols.any()) return emptyList()

        val functions = symbols.map {
            val name = it.simpleName.asString()
            val params = it.parameters.map(::resolveFunctionParam)
            Function(name, params)
        }
        val content = generateCode(functions)

        createTargetFile(resolver).run {
            write(content.toByteArray())
            close()
        }

        return symbols.filterInvalid()
    }

    private fun getFunctionSymbols(resolver: Resolver): Sequence<KSFunctionDeclaration> {
        return resolver
            .getSymbolsWithAnnotation("$packageName.WithDefaults")
            .filterIsInstance<KSFunctionDeclaration>()
    }

    private fun resolveFunctionParam(param: KSValueParameter): Param {
        val paramName = param.name?.asString() ?: throw IllegalArgumentException("Param is missing the name")
        val (typePackage, typeName) = param.type.resolve().declaration.run {
            packageName.asString() to simpleName.asString()
        }
        val nullable = param.type.resolve().isMarkedNullable
        val defaultValue = getTypeDefaultValue(typePackage, typeName, nullable)

        return Param(
            name = paramName,
            type = typeName,
            nullable = nullable,
            defaultValue = defaultValue,
        )
    }

    private fun getTypeDefaultValue(typePackage: String, typeName: String, nullable: Boolean): String? {
        return when (typePackage) {
            "kotlin" -> when (typeName) {
                "Number", "Int" -> "0"
                "Float" -> "0f"
                "Double" -> "0.0"
                "Boolean" -> "true"
                "String" -> "\"\""
                else -> if (nullable) "null" else null
            }

            else -> if (nullable) "null" else null
        }
    }

    private fun createTargetFile(resolver: Resolver): OutputStream {
        val sources = resolver.getAllFiles().toList().toTypedArray()

        return environment.codeGenerator.createNewFile(
            dependencies = Dependencies(false, *sources),
            packageName = packageName,
            fileName = "WithDefaults",
        )
    }

    private fun generateCode(functions: Sequence<Function>): String {
        val functionsContent = functions.map {
            val params = it.params.joinToString { param ->
                val name = param.name
                val type = ": ${param.type}" + if (param.nullable) "?" else ""
                val defaultOrEmpty = param.defaultValue.let { value -> " = $value" }
                name + type + defaultOrEmpty
            }
            val args = it.params.joinToString { param -> param.name }

            """
                |fun ${it.name}Default($params) {
                |  ${it.name}($args)
                |}
                |
            """.trimMargin()
        }.joinToString("")

        val content = """
            |package $packageName
            |
            |$functionsContent
            """.trimMargin()

        return content
    }
}

fun Sequence<KSAnnotated>.filterInvalid(): List<KSAnnotated> {
    return filterNot { it.validate() }.toList()
}

data class Function(
    val name: String,
    val params: List<Param>,
)

data class Param(
    val name: String,
    val type: String,
    val nullable: Boolean,
    val defaultValue: String?,
)
