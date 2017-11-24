import Vue from 'vue/dist/vue.esm';
import axios from 'axios';

const URL_BASE = 'http://localhost:3000/api/v1/records/';

var switchComponent = Vue.extend({
    template: '<button v-on:click="emitSwitch">切り替え</button>',
    methods: {
      emitSwitch: function() {
        this.$emit('switch')
      }
    }
});

new Vue({
  el: '#room-root',
  data: {
    chatDisplay: true,
    voteSelected: ""
  },
  created: function() {
    this.setInitialValue()
  },
  methods: {
    updateRecord(id) {
      axios.put(URL_BASE + id, { record: { vote_target_id: 1 } })
        .then(res => {
          console.log(res.data)
        });
    },
    switchArea: function() {
      this.chatDisplay = !this.chatDisplay
    },
    setInitialValue: function() {
      this.voteSelected = document.getElementById('vote-initial').getAttribute('initial')
    }
  },
  components: {
    'switch-component': switchComponent
  }
});
