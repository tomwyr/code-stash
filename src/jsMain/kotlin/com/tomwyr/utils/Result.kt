package com.tomwyr.utils

sealed class Result<out T, out F>
data object Loading : Result<Nothing, Nothing>()
class Success<T>(val value: T) : Result<T, Nothing>()
class Failure<F>(val value: F) : Result<Nothing, F>()
