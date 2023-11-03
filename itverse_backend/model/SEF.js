const mongoose = require("mongoose");

const sefSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, "A user must have a name"],
  },
  country:{
    type:String,
    required:[true,"A user must have a country"]
  },
  tgdp :[{
    year:{
      type:Number,
      required:[true,"A user must have a year"]
    },
    value:{
      type:Number,
      required:[true,"A user must have a value"]
    }
  }],
  gdpCapita :[{
    year:{
      type:Number,
      required:[true,"A user must have a year"]
    },
    value:{
      type:Number,
      required:[true,"A user must have a value"]
    }
  }],
  gdpGrowthRate :[{
    year:{
      type:Number,
      required:[true,"A user must have a year"]
    },
    value:{
      type:Number,
      required:[true,"A user must have a value"]
    }
  }],
  tpopulation :[{
    year:{
      type:Number,
      required:[true,"A user must have a year"]
    },
    value:{
      type:Number,
      required:[true,"A user must have a value"]
    }
  }],
    populationGrowth :[{
        year:{
        type:Number,
        required:[true,"A user must have a year"]
        },
        value:{
        type:Number,
        required:[true,"A user must have a value"]
        }
    }],
  createdAt: {
    type: Date,
    default: () => Date.now(),
  },


  updatedAt: {
    type: Date,
    default: () => Date.now(),
  },
});

const SEF = mongoose.model("SEF", sefSchema);
module.exports = SEF;