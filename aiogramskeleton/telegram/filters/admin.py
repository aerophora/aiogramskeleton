from typing import Any, cast

from aiogram.filters import Filter, MagicData
from aiogram.types import Message


class CheckAdmin(Filter):
    def __init__(self, names: list[int] | MagicData) -> None:
        self.names = names

    async def __call__(
        self, message: Message, *args: tuple[Any, ...], **kwargs: dict[str, Any]
    ) -> bool:
        if not message.from_user:
            return False

        if isinstance(self.names, MagicData):
            names = await self.names(message, *args, **kwargs)
            return message.from_user.id in cast(list[int], names)

        return message.from_user.id in self.names
