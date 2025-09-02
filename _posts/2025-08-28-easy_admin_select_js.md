---
title: "Easy Admin Crud Controller custom select with data from JS"
date: 2025-08-28
categories: DEV
tags: php symfony easyadmin
---

## Intro
* Use case
  * EasyAdmin crud controller
  * Entity virtual field 
  * This field has data populated by JS and it is select (Symfony ChoiceType)

## Problem
* Symfony ChoiceType is Transformable and this prevents form to be submitted with error `No proper value`

## Solution
* source [StackOverflow - post from 2017](https://stackoverflow.com/questions/41428553/removing-choicetype-transformers-during-pre-submit-events)

## Code
```php
<?php
declare(strict_types=1);

namespace App\Form;

use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\FormBuilderInterface;

class NonTransformedChoiceType extends ChoiceType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        parent::buildForm($builder, $options);
        $builder->resetModelTransformers();
        $builder->resetViewTransformers();
    }
}
```

```php
<?php
declare(strict_types=1);


namespace App\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\OptionsResolver\OptionsResolver;

class DynamicSelectType extends AbstractType
{
    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'choices' => [],
            'choice_value' => 'id',
        ]);
    }

    public function getParent(): string
    {
        return NonTransformedChoiceType::class;
    }
}
```

```php
# Easy Admin Crud Controller
public function configureFields(string $pageName): iterable
{
    yield Field::new('virtualField')->setLabel("Virtual Field Name")
            ->setFormType(DynamicSelectType::class)
            ->setFormTypeOptions([
                'row_attr' => ['class' => 'col-md-6'],
                'attr' => [
                    'class' => 'form-control virtual-field-selector', # virtual-field-selector - for JS to find this select and populate with required data
                ]
            ])->onlyOnForms();    
}

public function updateEntity(EntityManagerInterface $entityManager, $entityInstance): void
{
        if (!($entityInstance instanceof YourDesiredClass)) {
            return;
        }

        # perform $entityInstance update with data from virtualField

        parent::updateEntity($entityManager, $entityInstance);
}

public function persistEntity(EntityManagerInterface $entityManager, $entityInstance): void
{
        if (!($entityInstance instanceof YourDesiredClass)) {
            return;
        }

        # perform $entityInstance update with data from virtualField

        parent::persistEntity($entityManager, $entityInstance);
}
```

## Notes
* solution source : https://stackoverflow.com/questions/41428553/removing-choicetype-transformers-during-pre-submit-events
