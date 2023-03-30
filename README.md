#  Introducción

 
-   A medida que el usuario navega por la interfaz, el siguiente elemento enfocable en la dirección en la que el usuario está navegando se enfoca 

-   El sistema que controla el enfoque y el movimiento de dicho enfoque se llama motor de enfoque 

-   El motor de enfoque escucha los eventos de movimiento de enfoque entrantes en su aplicación. Cuando llega un evento, el motor de enfoque determina automáticamente el siguiente elemento enfocable y notifica a su aplicación 

-   El motor de enfoque actualiza el foco cuando el usuario envía un evento de movimiento o cuando la aplicación solicita una actualización del foco. 

-   Comportamiento del foco a tener en cuenta: 

-   Pueden haber elementos enfocables y elementos que no lo son. Para determinarlo hay que utilizar la propiedad canBecomeFocused 

-   CanBecomeFocused 

-   False: El elemento no se puede enfocar, incluso si está visible en la interfaz. 

-   True: El elemento se puede enfocar, pero el sistema no garantiza que sea siempre enfocable, ya que si elemento no es visible o está fuera de la pantalla es posible que no se pueda enfocar. Por ejemplo: Una UIView no se puede enfocar si la interacción del usuario está deshabilitada o el valor alfa es igual a 0. 

-   Solo un único elemento puede tener el foco en un momento dado 

-   Cuando el usuario cambia el enfoque moviéndose hacia una dirección en el control remoto, UIKit intenta mover el foco a un nuevo elemento de la interfaz en dicha dirección. Si el sistema encuentra otro elemento que acepte el foco, éste gana el enfoque. Si. No encuentra elemento en esa dirección, el elemento actualmente enfocado permanece enfocado y se emite una notificación movementDidFailNotification 

-   Mediante programación no se puede buscar un nuevo elemento en una dirección determinada. Es el usuario el que puede cambiar el enfoque direccionalmente. 

-   El enfoque es administrado por el entorno de enfoque (preferredFocusEnvironments). Esto significa que cada elemento puede tener sus entornos de enfoque, y si uno de sus entornos de enfoque gana el enfoque, puede mantenerlo o dar ese enfoque a uno de sus entornos de enfoque secundarios. 

-   PreferredFocusEnvironments 

-   Determina los entornos de enfoque a los que se  debe dirigir, ordenados por prioridad. 

-   Si se determinan entornos de enfoque, el sistema intentará redirigir el enfoque a cada entorno en orden, deteniéndose si encuentra un elemento enfocable en un entorno. 

-   Muchos elementos de UIKit son enfocables por defecto, por ejemplo los UIButton, los UITextField o las UITableViewCell 

-   El sistema enfocará al elemento más arriba a la izquierda (top-left) por defecto. En los idiomas rtl (de derecha a izquierda) el sistema enfocará al elemento más arriba a la derecha.
