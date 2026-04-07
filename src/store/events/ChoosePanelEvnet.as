package store.events
{
   import flash.events.Event;
   
   public class ChoosePanelEvnet extends Event
   {
      
      public static const CHOOSEPANELEVENT:String = "ChoosePanelEvent";
	  public static const CHOOSEPANELFORGEEVENT:String = "ChoosePanelForgeEvent";
       
      
      private var _currentPanel:int;
      
      public function ChoosePanelEvnet(event: String, param1:int)
      {
         this._currentPanel = param1;
         super(event,true);
      }
      
      public function get currentPanle() : int
      {
         return this._currentPanel;
      }
   }
}
