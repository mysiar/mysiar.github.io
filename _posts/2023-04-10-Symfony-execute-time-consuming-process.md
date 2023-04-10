---
title:  "Symfony - execute time consuming process in 'background'"
date:   2023-04-10
categories: DEV
tags: php symfony
---

Problem with timeout when running long jobs in Controller ?

Solution

* Controller
  ```php
    #[Route('/app/trigger', name: 'app-trigger')]
    public function trigger(): Response
    {
        return $this->redirectToRoute('you-desired-route'); // or any other response you like    
    }
  ```

* Listener
  ```php
  namespace App\Listener;
  
  use Symfony\Component\HttpKernel\Event\TerminateEvent;
  
  class TriggerListener
  {
       public function __construct(private readonly RouterInterface $router)
       public function onKernelTerminate(TerminaneEvent $event): void
       {
            $route = $this->router->match($event->getRequest()->getPathInfo());
            if ($route['_route'] !== 'app-trigger') {
                return;            
            }
  
            // do you long job here     
       }
  } 
  ``` 

* service definition
  ```yaml
     App\Listener\TriggerListener:
       arguments:
         - '@router'
       tags:
         - { name: kernel.event_listener, event: kernel.terminate}
  ```

