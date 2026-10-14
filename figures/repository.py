## @file
# @brief Репозиторий для чтения тегов из базы данных.

from sqlalchemy import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession

from domains.tag.model import Tag


## @brief Репозиторий тегов.
# @details Выполняет запросы к тегам через переданную асинхронную
# сессию SQLAlchemy.
class TagRepository:
    ## @brief Создаёт репозиторий тегов.
    # @param session Асинхронная сессия для выполнения запросов к БД.
    def __init__(self, session: AsyncSession):
        self.session = session

    ## @brief Возвращает список тегов.
    # @details Сейчас выбирает все теги: фильтр по is_active
    # закомментирован.
    # @return Список объектов Tag или пустой список, если записей нет.
    async def get_all_active_tags(self) -> list[Tag]:
        tags_stmt = select(Tag)
        # .where(
        #     Tag.is_active == True,
        # )

        db_tags = await self.session.scalars(tags_stmt)

        return list(db_tags.all())

    ## @brief Ищет тег по точному совпадению имени.
    # @param name Имя тега для поиска.
    # @return Первый найденный объект Tag или None, если совпадений нет.
    # @note Метод использует first(): при нескольких совпадениях
    # возвращается первое, а ошибка не возникает.
    async def get_tag_by_name(self, name: str) -> Tag | None:
        tag_stmt = select(Tag).where(
            Tag.name == name,
        )

        db_tag = await self.session.scalars(tag_stmt)

        return db_tag.first()

    ## @brief Ищет тег по идентификатору.
    # @details Вместе с тегом загружает связанные продукты через
    # selectinload(Tag.products).
    # @param tag_id Идентификатор тега.
    # @return Объект Tag или None, если тег не найден.
    async def get_tag_by_id(self, tag_id: int) -> Tag | None:
        tag_stmt = (
            select(Tag)
            .options(
                selectinload(Tag.products),
            )
            .where(
                Tag.id == tag_id,
            )
        )

        db_tag = await self.session.scalars(tag_stmt)

        return db_tag.first()

    ## @var session
    # @brief Асинхронная сессия SQLAlchemy, используемая репозиторием.
