---
title: "EasyAdmin custom filter on collection"
date: 2025-08-11
categories: DEV
tags: php symfony easyadmin
---

## Intro
* Use case, entity Person has collection of Tag entity objects
  * **Person**
     ```php
     #[ORM\OneToMany(targetEntity: Tag::class, mappedBy: 'person')]
     private Collection $tags;
    ```
  * **Tag**
     ```php
     #[ORM\ManyToOne(inversedBy: 'tags')]
     #[ORM\JoinColumn(nullable: true)]
     private ?Person $person = null;
    ```
* Built in filter `EntityFilter` didn't work

## Filter Person entity on Tag
This filters **Person** on all **Tag** objects existing in the system. Desired is to filter only on **Tag** objects assigned to **Person**
```php
final class TagCollectionFilter implements FilterInterface
{
    use FilterTrait;

    private LoggerInterface $logger;

    public static function new(string $propertyName, string $label): self
    {
        return (new self())
            ->setFilterFqcn(__CLASS__)
            ->setProperty($propertyName)
            ->setLabel($label)
            ->setFormType(EntityType::class)
            ->setFormTypeOptions([
                'class' => Tag::class,
                'choice_label' => 'name',
                'placeholder' => 'Select a tag',
                'required' => false,
                'multiple' => false,
            ]);
    }

    public function apply(
        QueryBuilder  $queryBuilder,
        FilterDataDto $filterDataDto,
        ?FieldDto     $fieldDto,
        EntityDto     $entityDto
    ): void
    {
        $value = $filterDataDto->getValue();
        $queryBuilder->join(sprintf('%s.%s', $filterDataDto->getEntityAlias(), $filterDataDto->getProperty()), 't')
            ->andWhere('t.id = :tag_id')
            ->setParameter('tag_id', $value->getId());
    }
}
```
to achieve filtering **Person** on **Tag** objects assigned to **Person** it is neccessary to add below code snippet to `->setFormTypeOptions`
```php
    'query_builder' => function (EntityRepository $er) {
                    return $er->createQueryBuilder('t')
                        ->where('t.person IS NOT NULL')
                        ->orderBy('t.name', 'ASC');
    },
```

## Full filter 
```php
<?php
declare(strict_types=1);

namespace App\Admin\Filter;

use App\Entity\Tag;
use Doctrine\ORM\EntityRepository;
use Doctrine\ORM\QueryBuilder;
use EasyCorp\Bundle\EasyAdminBundle\Contracts\Filter\FilterInterface;
use EasyCorp\Bundle\EasyAdminBundle\Dto\EntityDto;
use EasyCorp\Bundle\EasyAdminBundle\Dto\FieldDto;
use EasyCorp\Bundle\EasyAdminBundle\Dto\FilterDataDto;
use EasyCorp\Bundle\EasyAdminBundle\Filter\FilterTrait;
use Psr\Log\LoggerInterface;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;

final class TagCollectionFilter implements FilterInterface
{
    use FilterTrait;

    private LoggerInterface $logger;

    public static function new(string $propertyName, string $label): self
    {
        return (new self())
            ->setFilterFqcn(__CLASS__)
            ->setProperty($propertyName)
            ->setLabel($label)
            ->setFormType(EntityType::class)
            ->setFormTypeOptions([
                'class' => Tag::class,
                'choice_label' => 'name',
                'placeholder' => 'Select a tag',
                'required' => false,
                'multiple' => false,
                'query_builder' => function (EntityRepository $er) {
                    return $er->createQueryBuilder('t')
                        ->where('t.person IS NOT NULL')
                        ->orderBy('t.name', 'ASC');
                },
            ]);
    }

    public function apply(
        QueryBuilder  $queryBuilder,
        FilterDataDto $filterDataDto,
        ?FieldDto     $fieldDto,
        EntityDto     $entityDto
    ): void
    {
        $value = $filterDataDto->getValue();
        $queryBuilder->join(sprintf('%s.%s', $filterDataDto->getEntityAlias(), $filterDataDto->getProperty()), 't')
            ->andWhere('t.id = :tag_id')
            ->setParameter('tag_id', $value->getId());
    }
}
```

Implementation in EasyAdmin crud controller for **Person** entity
```php
public function configureFilters(Filters $filters): Filters
    {
        return $filters            
            ->add(TagCollectionFilter::new('tags', 'Tags'));
    }
```
