package store.equipGhost
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.Event;
   
   public class EquipGhostEvent extends Event
   {
       
      
      public var info:InventoryItemInfo;
      
      public var moveType:int;
      
      public function EquipGhostEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
