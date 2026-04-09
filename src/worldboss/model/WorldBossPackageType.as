package worldboss.model
{
   import flash.utils.describeType;

   public class WorldBossPackageType
   {

      public static const OPEN:int = 0;

      public static const OVER:int = 1;

      public static const CANENTER:int = 2;

      public static const MOVE:int = 6;

      public static const ENTER:int = 3;

      public static const WORLDBOSS_EXIT:int = 4;

      public static const WORLDBOSS_PLAYERSTAUTSUPDATE:int = 7;

      public static const WORLDBOSS_FIGHTOVER:int = 8;

      public static const WORLDBOSS_ROOM_CLOSE:int = 9;

      public static const WORLDBOSS_BLOOD_UPDATE:int = 5;

      public static const WORLDBOSS_RANKING:int = 10;

      public static const WORLDBOSS_PLAYER_REVIVE:int = 11;

      public static const WORLDBOSS_BUYBUFF:int = 12;

      public function WorldBossPackageType()
      {
         super();
      }

      private static var _valueToNames:Object;

      private static function init():void
      {
         _valueToNames = {};

         var xml:XML = describeType(WorldBossPackageType);

         for each (var constant:XML in xml.constant)
         {
            var name:String = constant.@name;
            var value:int = int(WorldBossPackageType[name]);

            if (!_valueToNames[value])
            {
               _valueToNames[value] = [];
            }

            _valueToNames[value].push(name);
         }
      }

      public static function getName(value:int):String
      {
         if (!_valueToNames)
         {
            init();
         }

         var list:Array = _valueToNames[value];

         return list ? list[0] : ("UNKNOWN(" + value + ")");
      }

   }
}
