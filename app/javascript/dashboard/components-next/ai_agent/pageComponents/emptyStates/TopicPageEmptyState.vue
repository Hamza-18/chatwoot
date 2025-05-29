<script setup>
import EmptyStateLayout from 'dashboard/components-next/EmptyStateLayout.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import TopicCard from 'dashboard/components-next/captain/topic/TopicCard.vue';
import FeatureSpotlight from 'dashboard/components-next/feature-spotlight/FeatureSpotlight.vue';
import { topicsList } from 'dashboard/components-next/captain/pageComponents/emptyStates/captainEmptyStateContent.js';

const emit = defineEmits(['click']);

const onClick = () => {
  emit('click');
};
</script>

<template>
  <FeatureSpotlight
    :title="$t('CAPTAIN.TOPICS.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
    :note="$t('CAPTAIN.TOPICS.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
    fallback-thumbnail="/assets/images/dashboard/captain/topic-light.svg"
    fallback-thumbnail-dark="/assets/images/dashboard/captain/topic-dark.svg"
    learn-more-url="https://chwt.app/captain-topic"
    class="mb-8"
  />
  <EmptyStateLayout
    :title="$t('CAPTAIN.TOPICS.EMPTY_STATE.TITLE')"
    :subtitle="$t('CAPTAIN.TOPICS.EMPTY_STATE.SUBTITLE')"
    :action-perms="['administrator']"
  >
    <template #empty-state-item>
      <div class="grid grid-cols-1 gap-4 p-px overflow-hidden">
        <TopicCard
          v-for="(topic, index) in topicsList.slice(0, 5)"
          :id="topic.id"
          :key="`topic-${index}`"
          :name="topic.name"
          :description="topic.description"
          :updated-at="topic.created_at"
        />
      </div>
    </template>
    <template #actions>
      <Button
        :label="$t('CAPTAIN.TOPICS.ADD_NEW')"
        icon="i-lucide-plus"
        @click="onClick"
      />
    </template>
  </EmptyStateLayout>
</template>
