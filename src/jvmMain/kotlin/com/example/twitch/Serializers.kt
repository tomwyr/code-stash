package com.example.twitch

import kotlinx.datetime.DayOfWeek
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.KSerializer
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.descriptors.PrimitiveKind
import kotlinx.serialization.descriptors.PrimitiveSerialDescriptor
import kotlinx.serialization.descriptors.SerialDescriptor
import kotlinx.serialization.descriptors.listSerialDescriptor
import kotlinx.serialization.encoding.Decoder
import kotlinx.serialization.encoding.Encoder

object OffDaysSerializer : KSerializer<OffDays> {
    @OptIn(ExperimentalSerializationApi::class)
    override val descriptor: SerialDescriptor = SerialDescriptor("OffDays", listSerialDescriptor<DayOfWeek>())

    override fun deserialize(decoder: Decoder): OffDays {
        return OffDays(ListSerializer(DayOfWeekSerializer).deserialize(decoder))
    }

    override fun serialize(encoder: Encoder, value: OffDays) {
        ListSerializer(DayOfWeekSerializer).serialize(encoder, value)
    }

}

object DayOfWeekSerializer : KSerializer<DayOfWeek> {
    override val descriptor: SerialDescriptor = PrimitiveSerialDescriptor("DayOfWeek", PrimitiveKind.STRING)

    override fun deserialize(decoder: Decoder): DayOfWeek {
        return when (val value = decoder.decodeString()) {
            "Mon" -> DayOfWeek.MONDAY
            "Tue" -> DayOfWeek.TUESDAY
            "Wed" -> DayOfWeek.WEDNESDAY
            "Thu" -> DayOfWeek.THURSDAY
            "Fri" -> DayOfWeek.FRIDAY
            "Sat" -> DayOfWeek.SATURDAY
            "Sun" -> DayOfWeek.SUNDAY
            else -> throw IllegalArgumentException("$value is not a valid day of the week.")
        }
    }

    override fun serialize(encoder: Encoder, value: DayOfWeek) {
        encoder.encodeString(when (value) {
            DayOfWeek.MONDAY -> "Mon"
            DayOfWeek.TUESDAY -> "Tue"
            DayOfWeek.WEDNESDAY -> "Wed"
            DayOfWeek.THURSDAY -> "Thu"
            DayOfWeek.FRIDAY -> "Fri"
            DayOfWeek.SATURDAY -> "Sat"
            DayOfWeek.SUNDAY -> "Sun"
        })
    }
}
