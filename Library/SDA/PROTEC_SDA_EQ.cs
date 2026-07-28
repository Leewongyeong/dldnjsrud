using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SCKIT.Library.SDA
{
    public class PROTEC_SDA_EQ : SCKIT.Library.Equipment
    {
        public string FLIPMODE { get; private set; }
        public int MAPROTATE { get; private set; }
        public PROTEC_SDA_EQ(SCKIT.EQConfiguration.EQConfig eqConfig)
            : base(eqConfig)
        {
            // TODO: Complete member initialization
            CONSTR = GlobalVariable.getIns().CONSTR_CRMS;
            // 110:STA, 140:SDA
            _OperList = new string[] { "110", "140" };
            messageHandler = new PROTEC_SDA_Handler(this);
            
        }
        public override Lot setCLot(string lotid)
        {
            return base.setCLot<PROTEC_SDA_LOT, PROTEC_SDA_EQ>(lotid);
        }

        internal void SetFlip(byte value)
        {
            if (value == 1) FLIPMODE = "FLIP";
            else if(value == 0) FLIPMODE = "NORMAL";
        }

        internal void SetMapRotate(byte value)
        {
            if (value == 0) MAPROTATE = 0;
            else if (value == 1) MAPROTATE = 180;
        }
    }
}
