---
title:  "EasyAdmin - DateFilter"
date:   2023-03-16
categories: DEV
tags: php easyadmin symfony
---

Sometimes I need filter only on dates despite entity has DateTime property.

EasyAdmin has DateTimeFilter but it filters on Date & Time.
I needed just pure Date filter with time set to 00:00:00 or 23:59:59 when required for range comparison.

It might not be the most elegant solution but works great for me

DateFilter code
```php
<?php

namespace App\EasyAdmin\Filter;

use DateTime;
use Doctrine\ORM\QueryBuilder;
use EasyCorp\Bundle\EasyAdminBundle\Contracts\Filter\FilterInterface;
use EasyCorp\Bundle\EasyAdminBundle\Dto\EntityDto;
use EasyCorp\Bundle\EasyAdminBundle\Dto\FieldDto;
use EasyCorp\Bundle\EasyAdminBundle\Dto\FilterDataDto;
use EasyCorp\Bundle\EasyAdminBundle\Filter\FilterTrait;
use EasyCorp\Bundle\EasyAdminBundle\Form\Filter\Type\DateTimeFilterType;
use EasyCorp\Bundle\EasyAdminBundle\Form\Type\ComparisonType;
use Symfony\Component\Form\Extension\Core\Type\DateType;

class DateFilter implements FilterInterface
{
    use FilterTrait;

    public static function new(string $propertyName, $label = null): self
    {
        return (new self())
            ->setFilterFqcn(__CLASS__)
            ->setProperty($propertyName)
            ->setLabel($label)
            ->setFormType(DateTimeFilterType::class)
            ->setFormTypeOptions([
                'comparison_type_options' => [
                    'choices' => [
                        'filter.label.is_after' => ComparisonType::GT,
                        'filter.label.is_after_or_same' => ComparisonType::GTE,
                        'filter.label.is_before' => ComparisonType::LT,
                        'filter.label.is_before_or_same' => ComparisonType::LTE,
                        'filter.label.is_between' => ComparisonType::BETWEEN,
                    ],
                ],
                'value_type' => DateType::class,
            ]);
    }

    public function apply(
        QueryBuilder  $queryBuilder,
        FilterDataDto $filterDataDto,
        ?FieldDto     $fieldDto,
        EntityDto     $entityDto
    ): void
    {
        $alias = $filterDataDto->getEntityAlias();
        $property = $filterDataDto->getProperty();
        $comparison = $filterDataDto->getComparison();
        $parameterName = $filterDataDto->getParameterName();
        $parameter2Name = $filterDataDto->getParameter2Name();
        $value = $filterDataDto->getValue();
        $value2 = $filterDataDto->getValue2();
        
        if ($value instanceof DateTime) {
            $value = new DateTime($value->format('Y-m-d') . ' 00:00:00');
        }
        
        if ($value2 instanceof DateTime) {
            $value2 = new DateTime($value->format('Y-m-d') . ' 23:59:59');
        }
        
        if ($comparison === ComparisonType::BETWEEN) {
            $queryBuilder->andWhere(
                sprintf('%s.%s BETWEEN :%s and :%s', $alias, $property, $parameterName, $parameter2Name)
            )
                ->setParameter($parameterName, $value)
                ->setParameter($parameter2Name, $value2);
        } else {
            $queryBuilder->andWhere(sprintf('%s.%s %s :%s', $alias, $property, $comparison, $parameterName))
                ->setParameter($parameterName, $value);
        }
    }
}
```

Usage
```php
# EasyAdmin Crud Controller

public function configureFilters(Filters $filters): Filters
{
    return $filters
        ->add(DateFilter::new('createdAt'));
}
```
